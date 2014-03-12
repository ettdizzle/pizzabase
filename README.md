pizzabase
=========

A demo app using [Sinatra](http://www.sinatrarb.com/) on JRuby with [Datomic](www.datomic.com) (via [Diametric](https://github.com/relevance/diametric)).

Notes
-----
* Only communicating with Datomic using the Peer service. The REST service has too many limitations.
* Avoiding using the ```enum``` type for datoms because Ruby has a hard time interpreting it.

Setup
-----
* Will need to manually set up Datomic free transactor (which saves data to a file), and run it before launching the app.
  * ```$ bin/transactor config/samples/free-transactor-template.properties```
  * On my low-memory DigitalOcean server, I need to pass additional flags ```-Xms80m -Xmx350m```
  * I made an alias in .bashrc ```alias start-datomic='~/src/datomic/bin/transactor -Xms80m -Xmx350m config/samples/free-transactor-template.properties &'```
* Will need to initially create the database using the Datomic console.
  * From Datomic root directory ```$ bin/shell```
  * ```String uri = "datomic:free://localhost:4334/pizzabase";```
  * ```Peer.createDatabase(uri);```

Todo
----
* Figure out if unnecessary migrations are running all the time with ```<Entity>.create_schema.get```
* Find a good way to deploy, perhaps with [TourqueBox](http://recipes.sinatrarb.com/p/deployment/jruby#label-Deployment+with+TorqueBox). Can everything be wrapped in a WAR file and deployed to Tomcat?
* Generate some sample data. Find an easy way to dump as raw text and then read in ala the [Seattle example](https://github.com/relevance/diametric/wiki/Seattle-Example).
* Automate Datomic startup (and shutdown?) and perhaps installation (including creating a new Datomic dB) with a bash script or rake.
