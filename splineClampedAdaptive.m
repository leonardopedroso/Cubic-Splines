function M = splineClampedAdaptive(x,y,D)
%% Descrição
% A função splineClamped resolve o sistema de eqauções lineares 
% necessário para determinar o valor da sengunda derivada de cada 
% um dos nós do spline completo interpolador, com espaçamento 
% não uniforme 
% A função recebe como input:
%   -x: o vetor de nós a usar na interpolação
%   -D: vetor (2x1) que corresponde às derivadas da função 
% interpolada nos nós extremos 
%   -y: o vetor dos valores da função interpolada em cada nó
% Retorna o vetor M das segundas derivadas em cada um dos nós
    
%% Criar matriz spline completo
% Podemos reduzir o problema do spline completo à resolução de 
% um sistema de equações lineares representado por uma matriz 
% tridiagonal de dimensões n+1 x n+1 (cf. relatório)
    
    n = size(x,2);
    A = zeros(n);
    
     %Matriz A - não é necessária (boa indicação para a 
     % criação das diagonais)
     %A(1,1:2) = [2 1]; %condições de fecho
     %A(n,n-1:n) = [1 2];
     %for i = 2:n-1
        %A(i,i-1:i+1) = [x(i)-x(i-1) 2*(x(i+1)-x(i-1)) x(i+1)-x(i)];
        
    %end
   
    B = zeros(n,1);
    %condições de fecho
    B(1) = (6/(x(2)-x(1)))*((y(2)-y(1))/(x(2)-x(1))-D(1));
    B(n) = (6/(x(n)-x(n-1)))*(D(2)-(y(n)-y(n-1))/(x(n)-x(n-1)));
    
    for i = 2:n-1
        B(i) = 6*((y(i+1)-y(i))/(x(i+1)-x(i))-...
                                (y(i)-y(i-1))/(x(i)-x(i-1)));
    end
    
    % vetrores representativos das diagonais inferior, superior e
    % principal, respetivamente
    a = zeros(n,1);
    c = zeros(n,1);
    b = zeros(n,1);
    
    % Contruir diagonais (cf. relatório)
    for i = 2:n
       a(i) =  x(i)-x(i-1);
    end
    
    
    for i = 1:n-1
       c(i) =  x(i+1)-x(i);
    end
    
    for i = 2:n-1
        b(i) = 2*(x(i+1)-x(i-1));
    end
    
    % Condições fronteira
    c(1) = 1;
    a(n) = 1;
    b(1) = 2;
    b(n) = 2;

    % resolver o sistema de equações lineares
    %M = A\B;
    M = Thomas(a,b,c,B);
    

end