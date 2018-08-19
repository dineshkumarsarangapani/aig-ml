function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


a1=[ones(size(X,1),1) X];
z2=a1*Theta1';
a2=sigmoid(z2);
a2=[ones(size(X,1),1) a2];
z3=a2*Theta2';
hypothesis = sigmoid(z3);
a3 = hypothesis;


logOfHypothesis = log(hypothesis);

% Convert Vector tp Matrix
I = eye(num_labels);
yMat = zeros(m, num_labels);
for i=1:m
  yMat(i, :)= I(y(i), :);
end

J = (1/m)*sum(sum((-yMat).*logOfHypothesis - (1-yMat).*log(1-hypothesis)));

% Theta without the bias terms
% so start from 2 to end
Theta1_Reg = Theta1(:,2:size(Theta1,2));
Theta2_Reg = Theta2(:,2:size(Theta2,2));

penalty=sum(sum(Theta1_Reg.^2))+sum(sum(Theta2_Reg.^2));
regularization = lambda*penalty/(2*m);



J= J+regularization;

%---- The below is done afrer randInitiazeWeights and SignmoidGradient ----%
d3=a3.-yMat;
d2=(d3*Theta2).* sigmoidGradient([ones(size(z2, 1), 1) z2]);
%size(d2)
d2 = d2(:, 2:end); % remove the two colums added
%size(d2)

delta2=d3'*a2;
delta1=d2'*a1;

% calculate regularized gradient
%The goal is that regularization of the gradient should not change the theta gradient(:,1) values (for the bias units) calculated in Step 8.
% So go from col 2 in theta, to adjust add zeros to first col
theta1_penalty = (lambda/m)*[zeros(size(Theta1, 1), 1) Theta1(:, 2:end)];
theta2_penalty = (lambda/m)*[zeros(size(Theta2, 1), 1) Theta2(:, 2:end)];
% Always remember that the delta/m is elementwise operation as
% the forloop will divide element wise  
Theta1_grad = delta1./m + theta1_penalty;
Theta2_grad = delta2./m + theta2_penalty;
% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
