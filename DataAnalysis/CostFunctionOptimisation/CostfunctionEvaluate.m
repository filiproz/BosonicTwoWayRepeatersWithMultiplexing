%This script evaluates the cost function and outputs optimal resources,
%rate and repeater spacing which minimise hte cost function



Ltot =10000;
Lfix = 50;

%Put the rate for different Ls into a single array
SecretKeyArray = zeros(5, Ltot/Lfix);
SecretKeyArray(1,1:size(SecretKeyArrayL05,2)) = SecretKeyArrayL05;
SecretKeyArray(2,1:size(SecretKeyArrayL10,2)) = SecretKeyArrayL10;
SecretKeyArray(3,1:size(SecretKeyArrayL20,2)) = SecretKeyArrayL20;
SecretKeyArray(4,1:size(SecretKeyArrayL25,2)) = SecretKeyArrayL25;
SecretKeyArray(5,1:size(SecretKeyArrayL50,2)) = SecretKeyArrayL50;

%Put total resources for different Ls into a single array
TotalResources = zeros(5, Ltot/Lfix);

TotalResources(1,:) = ResourcesL05(2,:);
TotalResources(2,:) = ResourcesL10(2,:);
TotalResources(3,:) = ResourcesL20(2,:);
TotalResources(4,:) = ResourcesL25(2,:);
TotalResources(5,:) = ResourcesL50(2,:);

%Put resources per repeater for different Ls into a single array
ResourcesPerRepeater = zeros(5, Ltot/Lfix);

ResourcesPerRepeater(1,:) = ResourcesL05(1,:);
ResourcesPerRepeater(2,:) = ResourcesL10(1,:);
ResourcesPerRepeater(3,:) = ResourcesL20(1,:);
ResourcesPerRepeater(4,:) = ResourcesL25(1,:);
ResourcesPerRepeater(5,:) = ResourcesL50(1,:);

%Evaluate cost function as total resources divded by the rate for all the
%configurations
CostFunction = zeros(5, Ltot/Lfix);

CostFunction(1,:) = double(ResourcesL05(2,:))./SecretKeyArray(1,:);
CostFunction(2,:) = double(ResourcesL10(2,:))./SecretKeyArray(2,:);
CostFunction(3,:) = double(ResourcesL20(2,:))./SecretKeyArray(3,:);
CostFunction(4,:) = double(ResourcesL25(2,:))./SecretKeyArray(4,:);
CostFunction(5,:) = double(ResourcesL50(2,:))./SecretKeyArray(5,:);

%For every distance find the configuration that minimises the cost function
[~,Ind] = min(CostFunction);

%Establish optimal repeater separation vs distance
OptimalRepSep = zeros(1, Ltot/Lfix);

for i = 1:Ltot/Lfix
    if Ind(i) == 1;
        OptimalRepSep(1,i) = 0.5;
    elseif Ind(i) == 2;
        OptimalRepSep(1,i) = 1;
    elseif Ind(i) == 3;
        OptimalRepSep(1,i) = 2;
    elseif Ind(i) == 4;
        OptimalRepSep(1,i) = 2.5;
    else
        OptimalRepSep(1,i) = 5;
    end
end

%Optimal total resources vs distance
OptimalTotalResources = zeros(1, Ltot/Lfix);

for i = 1:Ltot/Lfix
    OptimalTotalResources(1,i) = TotalResources(Ind(i),i);
end

%Optimal rate vs distance
OptimalSecretKeyArray = zeros(1, Ltot/Lfix);

for i = 1:Ltot/Lfix
    OptimalSecretKeyArray(1,i) = SecretKeyArray(Ind(i),i);
end

%Optimal resources per repeater vs distance
OptimalResourcesPerRepeater = zeros(1, Ltot/Lfix);

for i = 1:Ltot/Lfix
    OptimalResourcesPerRepeater(1,i) = ResourcesPerRepeater(Ind(i),i);
end
 