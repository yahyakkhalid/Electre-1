
## Methode ELECTRE1
## Fait par :
# AMHIL Younes
# ASSAAD Ahmed Amine
# KHALID Yahya

## Definition de la fonction ELECTRE 1
Electre1 <- function(tabPerformance, actions, criteres, poidsCriteres, seuil_c, seuil_d){
  
  # Verification des conditions d'execution
  if(nrow(tabPerformance) != length(actions))
    stop("Le nombre des rows doit etre egal au nombre des actions.")
  
  if(ncol(tabPerformance) != length(criteres))
    stop("Le nombre des rows doit etre egal au nombre des criteres.")
  
  if(ncol(tabPerformance) != length(poidsCriteres))
    stop("Le nombre des colonnes doit etre egal au nombre des poids des criteres donnees.")
  
  if(!is.numeric(poidsCriteres))
    stop("Type de donnees des poids criteres n'est pas compatible.")
  
  if(!("igraph" %in% rownames(installed.packages())))
    stop("Veuillez installer le package 'igraph'")
  
  # Importation de la librairie igraph
  library(igraph)
  
  # Declaration des variables
  nbr_lignes <- nrow(tabPerformance)
  nbr_col <- ncol(tabPerformance)
  
  matriceConcordance <- matrix(rep(0, nbr_lignes*nbr_lignes),
                               nbr_lignes,
                               nbr_lignes,
                               dimnames = list(actions, actions))
  
  matriceDiscordance <- matrix(rep(0, nbr_lignes*nbr_lignes),
                               nbr_lignes,
                               nbr_lignes,
                               dimnames = list(actions, actions))
  
  matriceSurClassement <- matrix(rep(0, nbr_lignes*nbr_lignes),
                                 nbr_lignes,
                                 nbr_lignes,
                                 dimnames = list(actions, actions))
  
  # Calcul de delta (l'amplitude maximum de tous les criteres) :
  temp <- c()
  for(j in 1:nbr_col)
    temp[j] <- max(tabPerformance[, j]) - min(tabPerformance[, j])
  delta <- max(temp)
  
  # Calcul du matrice de concordance & discordance
  for(i in 1:nbr_lignes){
    for(k in 1:nbr_lignes){
      if(i != k){
        
        pplus <- 0
        pegal <- 0
        
        # Calcul de p+ et p=
        for(j in 1:nbr_col){
          # p+
          if(tabPerformance[i, j] > tabPerformance[k, j])
            pplus <- pplus + poidsCriteres[j]
          
          # p=
          if(tabPerformance[i, j] == tabPerformance[k, j])
            pegal <- pegal + poidsCriteres[j]
        }
        # coeff. de concordance (P= + P+)/P 
        matriceConcordance[i, k] <- (pplus + pegal)/sum(poidsCriteres)
        
        # Calcul du max(gj(Ak) - gj(Ai)), j appartient a J-(Ai,Ak)
        max <- max(tabPerformance[k, ] - tabPerformance[i, ])
        # coeff. de discordance max(gj(Ak) - gj(Ai))/delta 
        matriceDiscordance[i, k] <- max/delta
        
        # Matrice de surclassement : affiche des 0 et des 1 obtenus depuis la relation de surclassement
        if(matriceConcordance[i, k] >= seuil_c & matriceDiscordance[i, k] <= seuil_d)
          matriceSurClassement[i, k] <- 1
      }
    }
  }
  
  print("Matrice de concordance")
  print(matriceConcordance)
  print("Matrice de discordance")
  print(matriceDiscordance)
  
  # Traçage du graphe
  plot(graph.adjacency(matriceSurClassement))
}
