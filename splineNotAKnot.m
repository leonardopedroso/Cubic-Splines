function M = splineNotAKnot(n,h,y)
%% Descrição
% A função splineNotAKnot resolve o sistema de eqauções 
% lineares necessário para determinar o valor da sengunda derivada
% de cada um dos nós do spline not a knot interpolador (i.e. com 
% continuidade na terceira derivada nos nós 1 e n-1), com 
% espaçamento uniforme. 
% A função recebe como input:
%   -n: número de troços do polinómio interpolador
%   -h: espaçamento (uniforme) usado na interpolação
%   -y: o vetor dos valores da função interpolada em cada nó
% Retorna o vetor M das segundas derivadas em cada um dos nós

%% Criar matriz spline not a knot
% Podemos reduzir o problema do spline not a knot à resolução 
% de um sistema de equações lineares representado por uma matriz 
% de dimensões n+1 x n+1 (cf. relatório)

    % criar a matriz A e B correspondente ao sistema de 
    % equações lineares (AM=B) que pretendemos resolver 
    % (cf. relatório)
    A = 4*diag(ones(n+1,1),0)+diag(ones(n,1),1)+diag(ones(n,1),-1);
    A(1,1:3) = [-1 2 -1];
    A(n+1,n-1:n+1) = [-1 2 -1];
    B = zeros(n+1,1);
    % introduzir os valores de B a partir do espamento, h, e vetor y 
    % (cf. relatório)
    for i = 1:n-1
        B(i+1) = (6/h^2)*(y(i+2)-2*y(i+1)+y(i));
    end
    % resolver o sistema de equações lineares
    M = A\B;
    
end
