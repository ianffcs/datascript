
#!/bin/bash
set -o errexit -o nounset -o pipefail
cd "`dirname $0`/.."
PATH="$PWD/.fvm/flutter_sdk/bin:$PATH"

rm -rf tmp/cljdbench
mkdir -p tmp/cljdbench/src/cljd
cat > tmp/cljdbench/deps.edn <<EOF
{:paths ["src" "../../bench"]
 :deps {org.clojure/clojure {:mvn/version "1.11.1"}
        tensegritics/clojuredart {:git/url "https://github.com/tensegritics/ClojureDart.git"
                                  :sha "c56e2dc1bef1841a7ce58ce2546946dd0be414e1"}
        io.github.wevre/transit-cljd {:git/tag "v0.8.36"
                                      :git/sha "d9541d0"}
        metosin/jsonista {:mvn/version "0.3.3"}
        datascript/datascript {:local/root "../../"}}
 :cljd/opts {:main datascript.bench.datascript
             :kind :dart}}
EOF

cd tmp/cljdbench
clojure -M -m cljd.build init
clojure -M -m cljd.build compile datascript.bench.datascript
dart run bin/cljdbench.dart $@
