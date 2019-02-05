%structure contenant les fonctions d'apprentissage test�es
trainFcs = [struct('name', 'traingd') struct('name', 'traingda') struct('name', 'traingdm') struct('name', 'traingdx')];

%structure contenant les fonctions de performance test�es
PerformanceFunction = [struct('name', 'mse') struct('name', 'sse')];

%le nombre de neurones dans la couche cach�e (une couche) 
NbNeurons = [5, 10, 15, 20, 25, 30, 35, 40];

%le nombre de neurones dans la couche cach�e (deux couches) 
NbNeurons2 = [1, 2, 3, 4, 5];

%le pourcentage de partitionnement pris � chaque fois pour l'apprentissage
%trainRatio
PercentPartition = [40, 50, 60, 70];

fprintf('******* Une seule couche cahch�e *******\n')
for l = 1 : length(PerformanceFunction)
    fprintf('Fonction de performance : ')
    disp(PerformanceFunction(l))
    for k = 1 : length(PercentPartition)
        fprintf('Train Ratio :  ')
        disp(PercentPartition(k))
        for j = 1 : length(trainFcs)
            fprintf('Fonction d''apprentissage :  \n')
            disp(trainFcs(j))
            %cr�ation des r�seaux de neurones selon NbNeurones
            for i = 1 : 1 : length(NbNeurons)
                %cr�ation du r�seau de neurones
                net = newff(NNInPutNorm, NNTarget, NbNeurons(i));
                net.trainFcn = trainFcs(j).name;
                net.performFcn = PerformanceFunction(l).name;
                
                %partitionnement de l'ensemble d'apprentissage
                net.divideParam.trainRatio = PercentPartition(k)/100; 
                net.divideParam.valRatio = ((100-PercentPartition(k))/2)/100;   
                net.divideParam.testRatio = ((100-PercentPartition(k))/2)/100;  
                [trainV, valV, testV, trainInd, valInd, testInd] = dividerand(NNInPutNorm, net.divideParam.trainRatio, net.divideParam.valRatio, net.divideParam.testRatio);
                [trainT, valT, testT] = divideind(NNTarget, trainInd, valInd, testInd);

                %modification des parameteres du r�seau
                net.trainParam.epochs = 500; 
                net.trainParam.show = 50;
                net.trainParam.lr = 0.3; 
                net.trainParam.max_fail = 10;

                %appel de la fonction ntrain qui fait 10 fois
                %l'apprentissage du meme r�seau puis retoune le meilleur
                fprintf('Nombre de neurones : ')
                disp(NbNeurons(i))
                ntrain(net, NNInPutNorm, NNTarget, 5);
            end
        end
    end
end

fprintf('******* Deux couches cahch�es *******\n')
for l = 1 : length(PerformanceFunction)
    fprintf('Fonction de performance :  ')
    disp(PerformanceFunction(l))
    for k = 1 : length(PercentPartition)
        fprintf('Train Ratio :  ')
        disp(PercentPartition(k))
        for j = 1 : length(trainFcs)
            fprintf('Fonction d''apprentissage :  \n')
            disp(trainFcs(j))
            %cr�ation des r�seaux de neurones selon NbNeurones2
            for i = 1 : 1 : length(NbNeurons2)
                %cr�ation du r�seau de neurones
                net = newff(NNInPutNorm, NNTarget, {NbNeurons2(i), NbNeurons2(i)});
                net.trainFcn = trainFcs(j).name;
                net.performFcn = PerformanceFunction(l).name;
                
                %partitionnement de l'ensemble d'apprentissage
                net.divideParam.trainRatio = PercentPartition(k)/100; 
                net.divideParam.valRatio = ((100-PercentPartition(k))/2)/100;   
                net.divideParam.testRatio = ((100-PercentPartition(k))/2)/100;  
                [trainV, valV, testV, trainInd, valInd, testInd] = dividerand(NNInPutNorm, net.divideParam.trainRatio, net.divideParam.valRatio, net.divideParam.testRatio);
                [trainT, valT, testT] = divideind(NNTarget, trainInd, valInd, testInd);

                %modification des parameteres 
                net.trainParam.epochs = 500; 
                net.trainParam.show = 50;
                net.trainParam.lr = 0.3; 
                net.trainParam.max_fail = 50;

                %appel de la fonction ntrain qui fait 10 fois
                %l'apprentissage du meme r�seau puis retoune le meilleur
                fprintf('Nombre de neurones : ')
                disp(NbNeurons(i))
                ntrain(net, NNInPutNorm, NNTarget, 10);
            end
        end
    end
end