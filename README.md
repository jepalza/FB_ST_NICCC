# FB_ST_NICCC
FreeBasic Demo Port of ST-NICCC 2000

Es "otra" conversion mas (port) de la demo original del Atari ST "ST-NICCC 2000"

https://www.youtube.com/playlist?list=PLHDxrzOvt6kQF1OHLNnfLGGdOdYA_vFRl

Esta demo en realidad son fotogramas de pelicula ya renderizados y almacenados. No se hacen cálculos en tiempo real como cabría pensar al verla. Son cuadros vectoriales almacenados como coordenadas, vertices y colores predefinidos, para crear una sensacion de renderizado en tiempo real, a través de sus 1760 cuadros de video.

Mi programa en FreeBasic únicamente lee esa información del fichero original que almacena los fotogramas, y los muestra en pantalla a 25fps.

Hoy dos variables útiles con las que hacer pruebas: una es la resolucion a través de la variable "escala", que en mi programa está en "x4", para llevar la resolución original de 255x200 pixels, a una mas moderna de 1024x800. Al ser vectores almacenados, es fácil darles factor de escala. 

La otra variable es la velocidad, que esta puesta en 40ms, mediante un simple "Sleep 40". Probar a poner "Sleep 1" como diversión.

