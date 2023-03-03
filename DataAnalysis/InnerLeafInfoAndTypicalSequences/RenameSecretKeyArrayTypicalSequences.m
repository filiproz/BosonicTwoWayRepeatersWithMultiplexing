%This script renames the SecretKeyArray to add the z info to the
%name.

z = 40;

newVar1 = sprintf('Intervalz%d', z); % Copy to new variable with new and different name.
eval([newVar1 '= SecretKeyArray'])
clear('SecretKeyArray', 'SumPXArray', 'SumPZArray', 'Lfix', 'z' ,'newVar1'); 