# [Electre 1](https://fr.wikipedia.org/wiki/ELECTRE#M%C3%A9thode_ELECTRE_I)
Implementation de l'algorithme `ELimination Et Choix Traduisant la RÉalité` sous R.
##
Ce script
- Affiche la matrice des indices de concordance.
- Affiche la matrice des indices de discordance.
- Trace le graphe de surclassement.

```html
Avant d'executer le script, vous devez installer le package <span style="color: #92433A">igraph</span>.
```

Exemple d'execution sous [RStudio](https://www.rstudio.com/products/rstudio/download/#download):
```R
  # Preparation des données
  tabPerformance <- matrix(c(10, 0, 0, 20, 20, 20,
                            20, 5, 10, 5, 10, 10,
                            5, 5, 0, 10, 15, 20,
                            10, 16, 16, 10, 10, 13,
                            16, 10, 7, 13, 13, 13), nrow=6)
  actions <- c("P1", "P2", "P3", "P4", "P5", "P6")
  criteres <- c("C1", "C2", "C3", "C4", "C5")
  poidsCriteres <- c(3, 2, 3, 1, 1)
  seuil_c <- 0.9
  seuil_d <- 0.15
  
  # Appel de la fonction Electre1
  Electre1(tabPerformance, actions, criteres, poidsCriteres, seuil_c, seuil_d)
```
```html
<span style="color: red">N.B.</span>.
```

Si l'execution de ce script prend beaucoup de temps, omettre la clause `if` dans la ligne `24`
