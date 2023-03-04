function Yield = AnalyticYieldPostselectionStrategy(p, k, NoLinks)
%This function calculates the yield (average number of end-to-end entangled
%pairs per protocol run) of the post-selection based protocol with
%only outer leaves (perfect inner leaves).

%Inputs:

%p -        probability of passing the postselection for each elementary link
%k -        number of multiplexing levels
%NoLinks -  total number of links, length of the repeater chain

%Output:
%Yield -    the obtained protocol yield

PElem = zeros(k+1,1);
PEndtoEnd = zeros(k+1,1);
Yield = 0;
% Establish the distribution over the number of multiplexed links
% successfuly generated over a single elementary link
for i = 0:k
    PElem(i+1) = binopdf(i,k,p);
end

%Iterate over all the different number of succesful end-to-end links
for i = 0:k
    % Create a 3-element array. The first entry is the probability that
    % over a single elementary link we get less than i successes, 2nd entry
    % that exactly i successes and third entry that more than i successes.
    pElemList = [sum(PElem(1:i)), PElem(i+1), sum(PElem(i+2:k+1))];
    %Create a mesh grid of 3 arrays, describing all the different configurations 
    %of how many links we have with less than i successes (X1), exactly i
    %successes (X2) and more than i successes (X3). The sum of the same entry 
    %across all the 3 arrays needs to add up to NoLinks.
    x1 = 0:NoLinks;
    x2 = 0:NoLinks;
    [X1,X2] = meshgrid(x1,x2);
    X3 = NoLinks-(X1+X2);
    %Now create an array of probabilities of all these configurations.
    Y = mnpdf([X1(:),X2(:),X3(:)],repmat(pElemList,(NoLinks+1)^2,1));
    Y = reshape(Y,NoLinks+1,NoLinks+1);
    % Sum the entries of the first column apart from the first entry.
    %First column corresponds to the configuration with no links with less
    %than i successes. The first entry corresponds to the scenario with all
    %links with more than i successes. The entries from 2 to the end correspond to
    %scenarios with no links with less than i successes, and at least one
    %link with exactly i successes. This sum gives the probability of
    %exactly i end-to-end links.
    PEndtoEnd(i+1) = sum(Y(2:end,1),'all');
end
%Calculate the yield, i.e. average number of end-to-end links
for i = 0:k
    Yield = Yield + i * PEndtoEnd(i+1);
end


end

