(ns cloud-scout.main
  (:gen-class)
  (:require
   [clojure.core.async :as a :refer [chan go go-loop <! >! <!! >!!  take! put! offer! poll! alt! alts! close! onto-chan!
                                     pub sub unsub mult tap untap mix admix unmix pipe
                                     timeout to-chan  sliding-buffer dropping-buffer
                                     pipeline pipeline-async]]
   [clojure.string]
   [clojure.spec.alpha :as s]
   [clojure.java.io :as io]))

(println "clojure.compiler.direct-linking" (System/getProperty "clojure.compiler.direct-linking"))
(clojure.spec.alpha/check-asserts true)
(do (set! *warn-on-reflection* true) (set! *unchecked-math* true))

(defn -main [& args]
  (println ::-main)
  (let [data-dir (-> (io/file (System/getProperty "user.dir")) (.getCanonicalPath))]
    (go)))

(comment

  (require
   '[cloud-scout.main]
   :reload)

  (-main)

  ;
  )