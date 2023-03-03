%This script renames the SecretKeyArray to add the parameter info to the
%name including squeezing, detection efficiency and repeater separation.


sigGKP = 0.14;
etad= 0.99;
L = 10;


newVar1 = sprintf('sigGKP%detad%dL%d', round(100*sigGKP), round(100*etad), L ); % Copy to new variable with new and different name.
eval([newVar1 '= SecretKeyArray'])
clear('SecretKeyArray', 'etad', 'sigGKP', 'L', 'Lfix', 'newVar1'); 