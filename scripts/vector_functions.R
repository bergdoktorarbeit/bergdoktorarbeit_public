# creating function



find_corners <- function(vec_f, vec_m) {

    # Definiere die Koordinaten der Spitze und der Mitte der Seite c
    x1 <- vec_f[1]
    y1 <- vec_f[2]
    x2 <- vec_m[1]
    y2 <- vec_m[2]

    # Bestimme den Abstand zwischen den Koordinaten 1 und 2
    h <- sqrt((y2 - y1)^2 + (x2 - x1)^2)

    # Berechne die Länge der Seite c
    variable_to_h = 1.3076
    c_length <- h / 2 * variable_to_h

    # Bestimme den Vektor, der von Koordinate 1 zu Koordinate 2 zeigt
    vec <- c(x2 - x1, y2 - y1)

    # Drehe den Vektor um 90 Grad im Uhrzeigersinn
    rotated_vec <- c(-vec[2], vec[1])

    # Skaliere den Vektor auf die Länge der Seite c
    scaled_vec <- rotated_vec / sqrt(sum(rotated_vec^2)) * c_length

    # Berechne die Koordinaten der beiden Punkte an der Seite c
    x3 <- x2 + scaled_vec[1]
    y3 <- y2 + scaled_vec[2]
    x4 <- x2 - scaled_vec[1]
    y4 <- y2 - scaled_vec[2]

    # Gib die Koordinaten der Punkte gerundet aus
    corner_1 = paste0(round(x3),",", round(y3))
    corner_2 = paste0(round(x4),",", round(y4))
    

    return(c(corner_1, corner_2))
}
   



# CHAT GPT: 
# Um die Koordinaten der Punkte an der Seite c des Dreiecks zu berechnen, können wir das folgende Verfahren verwenden:

# Bestimme den Abstand zwischen Koordinate 1 und Koordinate 2, um die Höhe h des Dreiecks zu erhalten.
# Berechne die Länge der Seite c des Dreiecks, indem du die Höhe h mit dem Verhältnis 1:1,3076 multiplizierst.
# Bestimme den Vektor, der von Koordinate 1 zu Koordinate 2 zeigt, und drehe ihn um 90 Grad, um einen Vektor zu erhalten, der parallel zur Seite c liegt.
# Skaliere diesen Vektor auf die Länge der Seite c, um die Koordinaten der beiden Punkte an der Seite c zu erhalten.
# In R und Dplyr können wir das folgendermaßen implementieren.
# Dieser Code definiert die Koordinaten der Spitze und der Mitte der Seite c, berechnet die Höhe des Dreiecks, die Länge der Seite c und schließlich die Koordinaten der beiden Punkte an der Seite c. 
# Das Ergebnis wird auf der Konsole ausgegeben. Du kannst die Werte der Koordinaten 1 und 2 sowie das Verhältnis der Längen von c und h anpassen, um verschiedene Dreiecke zu erstellen.