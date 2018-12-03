function M = splineClamped(n,h,D,y)
%% Descrição
% A função splineClamped resolve o sistema de eqauções lineares 
% necessário para determinar o valor da sengunda derivada de cada
% um dos nós do spline completo interpolador, com espaçamento 
% uniforme. 
% A função recebe como input:
%   -n: número de troços do polinómio interpolador
%   -h: espaçamento (uniforme) usado na interpolação
%   -D: vetor (2x1) que corresponde às derivadas da função interpolada
% nos nós extremos 
%   -y: o vetor dos valores da função interpolada em cada nó
% Retorna o vetor M das segundas derivadas em cada um dos nós
    
%% Criar matriz spline completo
% Podemos reduzir o problema do spline completo à resolução de um 
% sistema de equações lineares representado por uma matriz tridiagonal
% de dimensões n+1 x n+1 (cf. relatório)
    
    % criar a matriz A tridiagonal e B correspondente ao sistema 
    % linear (AM=B) que pretendemos resolver (cf. relatório)
    % A tem a seguinte representação, no entanto, consideremos apenas 
    %as suas digonais por forma a poupar memória
    %A = 4*diag(ones(n+1,1),0)+diag(ones(n,1),1)+diag(ones(n,1),-1);
    %A(1,1:2) = [2 1];
    %A(n+1,n:n+1) = [1 2];
    
    
    % introduzir os valores de B a partir do espamento, h, e vetor y 
    %(cf. relatório)
    B = zeros(n+1,1);
    B(1) = (6/h)*((y(2)-y(1))/h-D(1));
    for i = 1:n-1
        B(i+1) = (6/h^2)*(y(i+2)-2*y(i+1)+y(i));
    end
    B(n+1) = (6/h)*(D(2)-(y(n+1)-y(n))/h);
    
    %M = A\B;
    % resolver o sistema de equações lineares
    d = 4*ones(n+1,1);
    d(1) = 2;
    d(end) = 2;
    % As diagonais têm de ser passadas com a mesma dimensão, 
    % no entanto, a(1) e c(end), os valores que ficariam indefinidos 
    % não são usados pelo agoritmo
    M = Thomas(ones(n+1,1), d, ones(n+1,1), B);
    

end
