# Study-of-the-Growth-Cone-Dynamics

Los conos de crecimiento son estructuras importantes para la formación del sistema nervioso central y periférico, y para su mantenimiento durante la edad adulta. Los conos son estructuras altamente dinámicas, que viajan a través de los tejidos guiando el crecimiento axonal hasta alcanzar su tejido blanco.
La morfología del cono de crecimiento es un parámetro que nos indica la funcionalidad del cono de crecimiento. Esto es importante porque la extensión y la direccionalidad del cono de crecimiento dependen de esta funcionalidad.[[1]](#1)

Estudiar la morfometría geométrica en los movimientos de los conos de crecimiento, requiere abordar tres retos:

* Los límites difusos de los conos de crecimiento.
* La falta de puntos de referencia anatómicos.
* Alta dinámica de cambio en los patrones de crecimiento en el tiempo. 

A diferencia de otras estructuras anatómicas, el contorno de los conos de crecimiento puede no estar definido claramente, incluso en aquellos conos que presentan en un inicio, límites claramente definidos, pasará normalmente que a través de las fases de desarrollo sus límites sean difusos, podría elegirse un valor umbral para definir los límites del cono, pero la decisión de un nivel umbral arbitrario podría descartar información espacial valiosa del patrón, adicionalmente en el estudio temporal se presentan fuertes cambios de iluminación y ruido producto de otros elementos presentes en el medio que pueden ocluir secciones del cono de crecimiento. Por los interiores motivos, se deben de mejorar las imágenes para aumentar la información discriminativa incluida y asegurar que los factores antes mensionados no puedan influir de manera negativa en la extracción de características. 

El segundo reto hace referencia a la variabilidad de la forma del cono a menudo carente de puntos de referencia biologicos que permitan la comparación entre individuos. En este sentido, se puede representar la forma del cono de crecimiento separnadolo del fondo de la imagen (segmentación) como una nueva imagen binaria o máscara y de está manera a plicarla a mas de dos dimensiones (por ejemplo, la forma 2D + tiempo). No obstante, en un estudio temporal existe una alta correlación entre conos (pixeles redundantes), convirtiendose en un inconveniente para el análisis estadístico. Una extrategia para abordar este reto es, el análisis eigenshape descrito por MacLeod et al.[[2]](#2) y aplicado para el caso de growth cone por Goodhill et al. [[3]](#3). EL metodo eigenshape, representa la forma mediante las coordenadas (x,y) de un conjunto de puntos de referencia, colocados alrededor del perímetro del cono y seleccionados de tal manera que no dependan de la orientación específica del cono (“invariante a la rotación”), o bien alineando la población de modo que las regiones semejantes se encuentren en ubicaciones espaciales correspondientes. Los nuevos pares de coordenadas generados corresponden a un vector de números que representan cada contorno como un punto en un espacio de N dimensiones, luego de ésto, se aplica “Análisis de Componentes Principales” (PCA) para obtener las direcciones en el espacio de forma que capturan la mayor proporción de varianza [[3]](#3). 

El tercer reto, relacionado con el rapido cambio de forma, tamaño y posción requiere de muchas muestras (frames). Este hecho tiene una ventaja clara, el manejo de gran cantidad de muestras pretende obtener mejores estimadores de variación de la forma de los conos de crecimiento.


## Fases del Estudio 

### Time-Lapse pre_processing

Utilizando la aplicación <a href="https://www.mathworks.com/help/images/batch-processing-using-the-image-batch-processor-app.html">__Image Batch Processor__</a> (MathWorks), se realiza la segmentación y normalización espacial de los conos de crecimiento
para un lote de imagenes de un Time-Lapse en dos etapas:

1- __Configuración de parametros:__ se proporciona una interfaz gráfica de usuario (GUI), que permite visualmente realizar la segmentación al aplicar diferentes configuraciones con el objetivo de buscar la mejor segmentación.

* Open your MATLAB and run the Image Batch Processor with the following configuration script:

  - <a href="https://github.com/jsaenzBimcv/Study-of-the-Growth-Cone-Dynamics/tree/main/seg_Cone_Morphology"> seg_Cone_Morphology/conesSegmentation.m </a>
  
<p style="text-align:center">
<img src="./images/dicom2bids.png" >
</p>
<div style='text-align:center;'>
figure 1: DICOM to BIDS conversion with the tool Dcm2Bids
</div>



2- __Procesamiento de parametros__: Utiliza los parametros almacenados en el archivo config.dat para segmentar un lote de imágenes.

* Run the Image Batch Processor with the following configuration script:

```
seg_Cone_Morphology/conesSegmentation.m
```

### Extracción de características 

La técnica utilizada para la extracción de información referente a la forma del objeto (basada en contornos), es el __análisis Eigenshape__.
Eigenshape utiliza los datos de coordenadas (X,Y) del contorno del cono de crecimiento como un vector que describe la forma. Sin embargo, la lista de coordenadas que representan el contorno del cono, no se pueden comparar inmediatamente con otro contorno, estos puntos no estan espaciados de la misma manera, por lo que es necesario crear un nuevo conjunto que esté espaciado uniformemente a lo largo de la misma curva.

Para esto es necesario interpolar el conjunto de puntos a distancias fijas a lo largo de la curva en el espacio (2D) que forma el contorno. El método utilizado para calcular los puntos a lo largo de la curva, fue la interpolación cubica de Hermite a trozos (calculados usando pchip en Matlab (MathWorks, s.f.)). 

* Open your MATLAB and run the following script:
```
seg_Cone_Morphology/conesSegmentation.m
```
 ### Análisis de componentes principales 

El conjunto de coordenadas debe reducirse a una forma comprensible (de baja dimensión), para ello, la herramienta utilizada es el análisis de componentes principales (PCA). De esta forma, es posible mostrar los conos de crecimiento como puntos en un diagrama de dispersion bidimensional o tridimensional sin perder mucha información, indicando las principales direcciones de variación de la forma dentro de la muestra.

* Open your MATLAB and run the following script:
```
seg_Cone_Morphology/conesSegmentation.m
```

### Prerequisites

What things you need to install the software and how to install them

```
conesSegmentation.m
```

## Authors

* **Muñoz Lasso, DC.** (2017). - *Doctoral Thesis* - Fisiopatología de la ataxia de Friedreich: Transporte y degeneración axonal. Universitat Politècnica de València. ( https://doi.org/10.4995/Thesis/10251/92842)
* **Sáenz Gamboa, JJ.** (2017). - *Master Dissertation* - Estudio morfológico en Conos de Crecimiento Mediante Análisis de Componentes Principales Y Modelos Ocultos de Markov. Universitat Politècnica de València.

# References

<a id="1">[1]</a>  Muñoz Lasso, DC. (2017). Fisiopatología de la ataxia de Friedreich: Transporte y degeneración axonal. Universitat Politècnica de València. ( https://doi.org/10.4995/Thesis/10251/92842)

<a id="2">[2]</a>  MacLeod, N. (1999). Generalizing and extending the eigenshape method of shape space visualization and analysis. Paleobiology, 107-138.

<a id="3">[3]</a>  Goodhill, G. J., Faville, R. A., Sutherland, D. J., Bicknell, B. A., Thompson, A. W., Pujic, Z., ... & Scott, E. K. (2015). The dynamics of growth cone morphology. BMC biology, 13(1), 10.

## License

The Study-of-the-Growth-Cone-Dynamics is free and open source for academic/research purposes (non-commercial)¹.

¹ Some algorithms of the Study-of-the-Growth-Cone-Dynamics are free for commercial purposes and others not. First you need to contact the authors of your desired algorithm and check with them the appropriate license.

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


 ## Rights and permissions.

 <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>., which permits use, sharing, adaptation, distribution and reproduction in any medium or format, as long as you give appropriate credit to the original author(s) and the source, provide a link to the Creative Commons license, and indicate if changes were made. The images or other third party material in this article are included in the article's Creative Commons license, unless indicated otherwise in a credit line to the material. If material is not included in the article's Creative Commons license and your intended use is not permitted by statutory regulation or exceeds the permitted use, you will need to obtain permission directly from the copyright holder.


## Acknowledgments

This research was developed as part of the PhD research: __Study of the dynamics of axonal growth of sensory neurons in the yg8sr mouse model for Friedreich's ataxia__.
Researcher: __Dr. Diana Carolina Muñoz Lasso__, Universitat Politècnica de València. http://hdl.handle.net/10251/45095

In collaboration with: 
* <a href="https://www.uv.es/ciberer2/index.wiki">Laboratorio de Fisiopatología de las Enfermedades Raras</a>, Universitat de València
* <a href="http://www.cipf.es/cipf-fisabio-joint-research-unit-biomedical-imaging">Biomedical Imaging Mixed Joint Unit, Foundation for the Promotion of Health and Biomedical Research (FISABIO) and the Principe Felipe Research Center (CIPF), València, Spain.</a>


