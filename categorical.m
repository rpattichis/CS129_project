function [Y_Train, Y_Val, Y_Test] = categorical(Y_tr,Y_val,Y_test, NAMES)
%convert to categorical
Y_Train = NAMES(Y_tr);
Y_Val = NAMES(Y_val);
Y_Test = NAMES(Y_test);
end

