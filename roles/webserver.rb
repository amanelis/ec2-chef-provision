name "webserver"
description "webserver role"
run_list(
         "role[default]",
         "recipe[webserver]"
         )
