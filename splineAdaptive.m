function E = splineAdaptive(k,a,b,epsl,PlotGraph)
%% Descrição
% A função splineAdative interpola uma função dada pela função 
% splineFunction através de um spline completo, adaptativamente. Dito 
% por outras palavras, esta função interpola uma função num conjunto 
% ótimo de nós e menor possível de forma a que o erro seja inferior 
% a epsl.
% A função recebe como input:
%   -k: a função a interpolar
%   -a,b: os extremos do intervalo a interpolar
%   -epslon: o eero máximo permitido na interpolação
%   -PlotGraph:
%       -0: Não fazer o plot da função interpolada, do spline 
% interpolador
%           nem dos nós usados para a interpolação
%       -1: Apesentar os resultados em um gráfico
% Esta função retorna o valor absoluto do maior erro cometido na
% interpolação.

% Funções Usadas e intervalos normalmente usados
% k -> fk(x)
% f1(x) = log(1+x)      em [0,1]
% f2(x) = 1/(1+25*x^2)  em [-1,1]
% f3(x) = sin(x^2)      em [0, 3*pi/2]
% f4(x) = tanh(x)       em [-20,20]

%% Constantes
    % número de pontos usados para o tracar o gráfico do spline
    nG = 1000; 

%% Calcular nós
    % A função knotsAdaptiveSpline seleciona um conjunto de pontos
    % ótimo para interpolar a função no intervalo a,b e com erro 
    % inferior a epsl
    [x,y,D] = knotsAdaptiveSpline(k,a,b,epsl);
    
    
%% Obter o vetor M
% O vetor M, o vetor com o valor das segundas derivadas do spline 
%interpolador em cada um dos nós
    
    % Resolver o sistema para cada tipo de spline
   
    % obter as derivadas da função interpolada nos nós extremos
    M = splineClampedAdaptive(x,y,D);
    
%% Criar gráfico
    % instanciar o vetor com os x dos pontos do gráfico
    xG = [a:(b-a)/nG:b]; 
    % calcular os valores do spline interpolador nos pontos x onde
    % pretendemos traçar o gráfico a partir da função splineFunction
    yGs = splineFunctionAdaptive(xG,x,y,M);
    % calcular os valores da função interpolada nos pontos x do gráfico
    yGf = funChoice(xG,k,0); 
    
    if(PlotGraph)
        figure;
        plot(xG,yGs); % plot do spline interpolador 
        hold on;
        scatter(x,y); % plot da função interpolada
        plot(xG,yGf); % plot dos nós usados para a interpolação
        hold off;
    end
    
%% Análise de erro
% Análise do erro cometido na interpolação e cálculo de E
    % vetor do erro de cada ponto calculado para o gráfico
    yGe = yGf-yGs; 
    % valor absoluto do maior dos erros cometidos na interpolação
    E = max(abs(yGe)); 
    if(PlotGraph)
        figure;
        plot(xG,yGe); % plot da função de erro na interpolação
        hold off;
        % Print do valor do erro máximo na command window
        fprintf("Erro máximo na interpolação é: %f\n", E);
    end
   
    
end
