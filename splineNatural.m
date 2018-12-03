function M = splineNatural(n,h,y)
%% Descrição
% A função splineNatural resolve o sistema de eqauções lineares
% necessário para determinar o valor da sengunda derivada de cada
% um dos nós do spline natural interpolador, com espaçamento uniforme. 
% A função recebe como input:
%   -n: número de troços do polinómio interpolador
%   -h: espaçamento (uniforme) usado na interpolação
%   -y: o vetor dos valores da função interpolada em cada nó
% Retorna o vetor M das segundas derivadas em cada um dos nós

%% Criar matriz spline natural
% Podemos reduzir o problema do spline natural à resolução de um 
% sistema de equações lineares representado por uma matriz 
% tridiagonal de dimensões n-1 x n-1 uma vez que M0 = 0 e Mn = n
% (cf. relatório)
    
    % Vetor dos n+1 valores das segundas derivadas em cada nó
    M = zeros(n+1,1); 
    % criar a matriz A tridiagonal e B correspondente ao 
    % sistema linear (AM=B) que pretendemos resolver (cf. relatório)
    %A = 4*diag(ones(n-1,1),0)+diag(ones(n-2,1),1)+...
                                        %diag(ones(n-2,1),-1);
    B = zeros(n-1,1);
    % introduzir os valores de B a partir do espamento, h, e vetor y 
    % (cf. relatório)
    for i = 1:n-1
        B(i) = (6/h^2)*(y(i+2)-2*y(i+1)+y(i));
    end

    % As diagonais têm de ser passadas com a mesma dimensão,
    % no entanto, a(1) e c(end), os valores que ficariam 
    % indefinidos não são usados pelo agoritmo
    M(2:n) = Thomas(ones(n-1,1),4*ones(n-1,1),ones(n-1,1),B);

    
end

