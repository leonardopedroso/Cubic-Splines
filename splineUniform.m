function E = splineUniform(s,k,a,b,n,d,PlotGraph,filenameS)
%% Descrição
% A função splineUniform interpola uma função dada pela função 
% splineFunction através de um spline: 
%                       - Natural para s=0
%                       - Completo para s=1
%                       - Not a Knot para s=2
% A função recebe como input:
%   -s: o tipo de spline a usar
%   -k: a função a interpolar
%   -a,b: os extremos do intervalo a interpolar
%   -n: número de troços a usar na interpolação
%   -d: vetor 1x3 que contem a informação da função ou derivadas
% de interesse
%   i.e. d(1)=1 significa fazer o estudo e gráfico para a 
% função e 0 o oposto
%        d(2)=1 significa fazer o estudo e gráfico para a 
% primeira derivada e 0 o oposto etc
%   -PlotGraph:
%       -0: Não fazer o plot da função interpolada, do spline 
% interpolador nem dos nós usados para a interpolação
%       -1: Apesentar os resultados em um gráfico
% Esta função retorna o valor absolto do maior erro cometido na
% interpolação, E. E vai ser um vetor de dimensão igual ao número 
% de 1s em d

% Funções Usadas e intervalos normalmente usados
% k -> fk(x)
% f1(x) = log(1+x)      em [0,1]
% f2(x) = 1/(1+25*x^2)  em [-1,1]
% f3(x) = sin(x^2)      em [0, 3*pi/2]
% f4(x) = tanh(x)       em [-20,20]

%% Constantes
% número de pontos usados para o tracar o gráfico do spline
    nG = 1000; 

%% Iniciar nós
    h = (b-a)/n; % calcular o espaçamento (uniforme)
    x = [a:h:b]; % instanciar o vetor com os x dos n+1 nós
    % instanciar o valores de y correspondes a cada um dos nós
    y = funChoice(x,k,0);

%% Obter o vetor M
% O vetor M, o vetor com o valor das segundas derivadas do spline 
%interpolador em cada um dos nós, é obtido de forma diferente 
% consoante o tipo de spline que usamos para interpolar a função k
    
    % Resolver o sistema para cada tipo de spline
    switch s
        case 0 % spline natural
            M = splineNatural(n,h,y); 
        case 1 %spline completo
            % obter as derivadas da função interpolada nos nós extremos
            D = funChoice(x,k,1); 
            M = splineClamped(n,h,D,y);
        case 2 % spline not a knot
            M = splineNotAKnot(n,h,y);
    end
    
%% Criar gráfico da função, suas derivadas, e erros

    xG = [a:(b-a)/nG:b]; % instanciar o vetor com os x dos pontos
    % do gráfico calcular os valores do spline interpolador nos 
    % pontos x onde pretendemos traçar o gráfico a partir da função 
    % splineFunction
    
    E = [];
    
    if (d(1) == 1)
        yGs = splineFunction(xG,x,y,M);
        % calcular os valores da função interpolada para os pontos
        % x do gráfico
        yGf = funChoice(xG,k,0);
        % vetor do erro de cada ponto calculado para o gráfico
        yGe = yGf-yGs; 
        E = [E max(abs(yGe))]; 
    end
    
    if (d(2) == 1)
        yGsD = splineFunctionD(xG,x,y,M);
        % calcular os valores da derivada da função para os pontos
        %x do gráfico
        if(~isa(k, 'function_handle'))
            yGfD = funChoice(xG,k,2);
            % vetor do erro de cada ponto calculado para o gráfico
            yGeD = yGfD-yGsD; 
            E = [E max(abs(yGeD))];
        end
    end
    
    if (d(3) == 1)
        yGsDD = splineFunctionDD(xG,x,M);
        if(~isa(k, 'function_handle'))
            % calcular os valores da 2ª derivada da função para os
            % pontos x do gráfico
            yGfDD = funChoice(xG,k,3);
            % vetor do erro de cada ponto calculado para o gráfico
            yGeDD = yGfDD-yGsDD; 
            E = [E max(abs(yGeDD))];
        end
    end
    
    
    % Gráficos das funções a ser estudadas
    if(PlotGraph)
        if(d(1) == 1)
            figure;     
            subplot(2,1,1);
            plot(xG,yGf);
            hold on;
            scatter(x,y);
            plot(xG,yGs);
            title('f(x)')
            legend({'f(x)','Nós','s(x)'})
            subplot(2,1,2);
            plot(xG,yGe);
            title('Erro')
            hold off;
            fprintf("Erro máximo absoluto para h = %f uniforme para f(x) é %f\n", h, E(1));
        end
        if(d(2) == 1)
            figure; 
            if(~isa(k, 'function_handle'))
                subplot(2,1,2);
                plot(xG,yGeD);
                title('Erro');
                subplot(2,1,1);
                plot(xG,yGfD);
                hold on;
                fprintf("Erro máximo absoluto para h = %f uniforme para f´(x) é %f\n", h,E(2));
                plot(xG,yGsD);
                title('f´(x)');
                legend({'f´(x)','s´(x)'})
            else
                plot(xG,yGsD);
                title('f´(x)');
            end
            
            hold off;
            
        end
        if(d(3) == 1)
            figure; 
            if(~isa(k, 'function_handle'))
                subplot(2,1,2);
                plot(xG,yGeDD);
                title('Erro');
                subplot(2,1,1);
                plot(xG,yGfDD);
                hold on;
                fprintf("Erro máximo absoluto para h = %f uniforme para f´´(x) é %f\n", h, max(abs(yGe)));
                plot(xG,yGsDD);
                title('f´´(x)');
                legend({'f´´(x)','s´´(x)'})
            else
                plot(xG,yGsDD);
                title('f´´(x)');
                hold off;
            end  
        end
    end
    
    % Guardar, se pedido, o ficheiro com informação reltiva à função
    % interpoladora
    if (isa(filenameS, 'string') || isa(filenameS, 'char')...
                                    && ~strcmp(filenameS,""))
        saveSpline(x,y,M,filenameS);
    end
   
end