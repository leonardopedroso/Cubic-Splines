function plotSplineFromTxt(filename)
%% Descrição
% A função saveSpline serve para importar e desenhar um spline 
% que foi guardado num ficheiro de texto através da função saveSpline.
% A função recebe como input:
%   -sfilename: o nome do ficheiro onde estão guardados os dados

%% Importar pontos
    fid = fopen(filename,'rt'); % abrir o fichero de texto dos dados
    if(fid<=3) % falha na abertura do ficheiro
        fprintf("Erro na abertura do ficheiro %s\n", filename);
    end
    % importar os valores e organiza-los numa matriz
    D = cell2mat(textscan(fid, '%f%f%f', 'MultipleDelimsAsOne',true ...
        ,'Delimiter',' ', 'HeaderLines',0));
    fclose(fid); % fechar o ficheiro
        
    if(max(size(D))==0) % Se não for possível extrair valores
        fprintf("Erro na abertura do ficheiro %s\n", filename);
    end
    
    nG = 1000;  
%% Criar gráfico
    
    % instanciar o vetor com os x dos pontos do gráfico
    xG = [D(1,1):(D(end,1)-D(1,1))/nG:D(end,1)]; 
    % calcular os valores do spline interpolador nos pontos x onde
    % pretendemos traçar o gráfico a partir da função
    % splineFunctionAdaptive uma vez que o espaçamento pode ser 
    % variável
    yGs = splineFunctionAdaptive(xG,D(:,1)',D(:,2)',D(:,3)');
    % calcular os valores da função interpolada para os pontos x 
    % do gráfico

    figure;
    plot(xG,yGs); % plot do spline interpolador 
    t = xlabel('x');
    t.Color = 'blue';
end

