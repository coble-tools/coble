# dry run
bash bin/coble-bash.sh \
       --steps "create,export,errors,missing" \
       --input "config/coble-test.yml" \
       --results "results/coble-test" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "./envs/coble-test" \
       --pkg "./pkgs/coble-test" \
       --output results/coble-test.out \
       --error logs/coble-test.err

