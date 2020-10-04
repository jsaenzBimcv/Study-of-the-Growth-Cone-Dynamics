# Study-of-the-Growth-Cone-Dynamics

Los conos de crecimiento son estructuras importantes para la formación del sistema nervioso central y periférico, y para su mantenimiento durante la edad adulta. Los conos son estructuras altamente dinámicas, que viajan a través de los tejidos guiando el crecimiento axonal hasta alcanzar su tejido blanco.
La morfología del cono de crecimiento es un parámetro que nos indica la funcionalidad del cono de crecimiento. Esto es importante porque la extensión y la direccionalidad del cono de crecimiento dependen de esta funcionalidad.

Estudiar la morfometría geométrica en los movimientos de los conos de crecimiento, requiere abordar tres retos:

•   Los límites difusos de los conos de crecimiento, 
•   La falta de puntos de referencia anatómicos y 
•   Alta dinámica de cambio en los patrones de crecimiento en el tiempo. 

A diferencia de otras estructuras anatómicas, el contorno de los conos de crecimiento puede no estar definidos claramente, incluso en aquellos conos que presentan en un inicio, límites claramente definidos, pasará normalmente que a través de las fases de desarrollo sus límites sean difusos, podría elegirse un valor umbral para definir los límites del cono, pero la decisión de un nivel umbral arbitrario podría descartar información espacial valiosa del patrón

## Fases del Estudio 

### Time-Lapse pre_processing

Para la segmentación y normalización espacial de los conos de crecimiento se utiliza la aplicación __Image Batch Processor__ (MathWorks), para procesar el lote de imagenes de un Time-Lapse en dos etapas:

1- Configuración de parametros: se proporciona una inetrfaz gráfica de usuario (GUI), que permite visualmente realizar la segmentación al aplicar diferentes configuraciones con el objetivo de buscar la mejor segmentación.

* Open your MATLAB and run the following setup script:

```
seg_Cone_Morphology/conesSegmentation.m
```






## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
conesSegmentation.m
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

The Study-of-the-Growth-Cone-Dynamics is free and open source for academic/research purposes (non-commercial)¹.

¹ Some algorithms of the Study-of-the-Growth-Cone-Dynamics are free for commercial purposes and others not. First you need to contact the authors of your desired algorithm and check with them the appropriate license.

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc

