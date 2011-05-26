name "box"
description "box role"
run_list(
         "role[default]",
         "recipe[box::packages]",
         "recipe[box::templates]"
         )
