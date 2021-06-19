Electre1 <- function(tabPerformance, actions, criteres, poidsCriteres, minMaxCriteres, seuil_c, seuil_d){
  
  # Verification des conditions d'execution
  if(nrow(tabPerformance) != length(actions))
    stop("Le nombre des rows doit etre egal au nombre des actions.")
  
  if(ncol(tabPerformance) != length(criteres))
    stop("Le nombre des rows doit etre egal au nombre des criteres.")
  
  if(ncol(tabPerformance) != length(poidsCriteres))
    stop("Le nombre des colonnes doit etre egal au nombre des poids des criteres donnees.")
  
  if(!is.numeric(poidsCriteres))
    stop("Type de donnees des poids criteres n'est pas compatible.")
  
  # Importation du package igraph
  library(igraph)
  
  # Declaration des variables
  nbr_lignes <- nrow(tabPerformance)
  nbr_col <- ncol(tabPerformance)
  matriceSurClassement <- matrix(0, nbr_lignes, nbr_lignes)
  
  # Min-max critères
  if(!(is.na(match("min", minMaxCriteres))))
    for(j in 1:nbr_col)
      if (minMaxCriteres[j] == "min")
        for (i in 1:nbr_lignes)
          tabPerformance[i,j] =  max(tabPerformance[, j]) - tabPerformance[i,j]

  # Calcul de delta (l'amplitude maximum de tous les criteres) :
  temp <- c()
  for(j in 1:nbr_col)
    temp[j] <- max(tabPerformance[, j]) - min(tabPerformance[, j])
  delta <- max(temp)
  
  # Calcul du matrice surclassement
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
        C <- (pplus + pegal)/sum(poidsCriteres)
        
        # coeff. de discordance max(gj(Ak) - gj(Ai))/delta ou j appartient a J-(Ai,Ak)
        D <- max(tabPerformance[k, ] - tabPerformance[i, ])/delta
        
        # Matrice de surclassement
        ## affiche des 0 et des 1 obtenus depuis la relation de surclassement
        if(C >= seuil_c & D <= seuil_d)
          matriceSurClassement[i, k] <- 1
      }
    }
  }
  
  # Traçage du graphe
  plot(graph.adjacency(matriceSurClassement))
}
