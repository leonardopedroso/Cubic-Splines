function beam(filename,filenameSave)
%% Descrição
% A função beamUniform interpola um conjunto de pontos (x,y) obtidos
% experimentalmente de um modo de vibração viga encastrada em ambas as
% extremidades, em que os pontos têm um espaçamento uniforme. 
% Para a resolução deste problema usaremos um spline completo (cf.
% relatório) com derivadas nulas nas extremidades.
% A função recebe como input o nome do ficheiro no qual estão gurdados
% os valores de (x,y) da viga organizados em duas colunas e o nome do 
% ficheiro em que pode ser guardado o spline. Se este nome for 
% inválido não é guardado

%% Constantes
    nG = 500; % número de pontos usados para o traçar o gráfico da viga

%% Importar pontos
    fid = fopen(filename,'rt'); % abrir o fichero de texto dos dados
    % importar os valores e organiza-los numa matriz
    V = cell2mat(textscan(fid, '%f%f', 'MultipleDelimsAsOne',true ...
        ,'Delimiter',' ', 'HeaderLines',0));
    fclose(fid); % fechar o ficheiro

%% Obter o vetor M
    % Sabemos que a derivada nos nós extremo de uma viga encastrada em
    % ambas as extremidades é nula nesses pontos pelo que D é nulo
    D = [0;0];
    % Calcular o vetor das segundas derivadas do spline interpolador em
    % cada um dos nós
    % Usando a função splineClampedAdaptive é possível interpolar 
    % corretamente o modo de vibração da viga para nós com espaçamento não
    % uniforme
    M = splineClampedAdaptive(V(:,1)',V(:,2)',D);
    
    
%% Criar gráfico
    xG = [0:1/nG:1]; % instanciar o vetor com os x dos pontos do gráfico
    % calcular os valores do spline interpolador nos pontos x onde
    % pretendemos traçar o gráfico a partir da função splineFunction
    yG = splineFunctionAdaptive(xG,V(:,1)',V(:,2)',M);
    figure;
    plot(xG,yG); % plot do spline interpolador
    hold on;
    scatter(V(:,1),V(:,2)); % plot dos valores experimentais
    title('Deslocamento vertical da viga')
    xlabel('x [m]');
    ylabel('w(x)');
    hold off;

% Criar gráfico da primeira derivada
    DyG = splineFunctionD(xG,V(:,1)',V(:,2)',M);
    figure;
    plot(xG,DyG); % plot do spline interpolador
    hold on;
    title('Rotação da viga')
    xlabel('x [m]');
    hold off;
    
% Criar gráfico da segunda derivada
    DDyG = splineFunctionDD(xG,V(:,1)',M');
    figure;
    plot(xG,DDyG); % plot do spline interpolador
    hold on;
    title('Curvatura da viga');
    xlabel('x [m]');
    hold off;

%% Guardar
    %Só guarda o spline num ficheiro se o nome for válido 
    if (isa(filenameSave, 'string') || isa(filenameSave, 'char') ...
                                          && ~strcmp(filenameSave,""))
        saveSpline(V(:,1)',V(:,2)',M,filenameSave);
    end
end