function [bestTrPerf, bestTrRegress, bestTr, bestNet, Output] = ntrain(net, NNInPutNorm, NNTarget, n)

            %******************************* Premiere itération *******************************%
			%lancer l'apprentissage
    		[net, tr] = train(net, NNInPutNorm, NNTarget);
			
			%calculer la regression
			[r,~,~] = regression(NNTarget, net(NNInPutNorm));
			
			%sauvegarder le réseau et sa trace (the first one)
			bestTrPerf = tr.best_perf;
			bestTr = tr;
			bestNet = net;
			bestTrRegress = mean(r);
			
			%Simuler le réseau (net) en NNInPutNorm (resultat mis dans Output)
			%Error = NNTarget - bestNet(NNInPutNorm);
            %fprintf('errors = %f\n',Error);
            
			%Initialisation des totals
			totalPerf = tr.best_vperf; %validation performance
			totalEpochs = tr.best_epoch;
			totalReg = mean(r);
			
            %******************************* Les n-1 itérations restantes *******************************%
            
		for i = 1 : 1 : n-1
			net = init(net);
			[net, tr] = train(net, NNInPutNorm, NNTarget);
			[r,~,~] = regression(NNTarget, net(NNInPutNorm));
			totalPerf = totalPerf + tr.best_vperf;
			totalEpochs = totalEpochs + tr.best_epoch;
			totalReg = totalReg + mean(r);
			Output = net(NNInPutNorm); %simulation du réseaux

			if tr.best_perf<bestTrPerf && mean(r)>bestTrRegress
				bestTrPerf = tr.best_perf;
				bestTrRegress = mean(r);
				bestNet = net;
				bestTr = tr;
				Output = bestNet(NNInPutNorm); %simulation du réseaux
			end
		end
		       
		fprintf('Best performance achieved :')
		disp(bestTrPerf)
		
		fprintf('Best regression achieved :')
		disp(bestTrRegress)
				
		%Visualisation l'architecture du meilleur reseau de neurone parmi
		%les 10 testés
			%view(bestNet);
            %courbe de regression
			plotregression(NNTarget,Output)
            %Courbe de performance
			plotperform(bestTr)
            %Error = NNTarget - Output; %output est calculé dans la boucle
            %fprintf('errors = %f\n',Error);