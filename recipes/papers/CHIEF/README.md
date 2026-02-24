# Chief
https://github.com/hms-dbmi/CHIEF?tab=readme-ov-file
https://www.nature.com/articles/s41586-024-07894-z

```
code/coble build \
--recipe recipes/papers/CHIEF/chief.cbl \
--env chief-dev \
--validate recipes/papers/chief/validate/validate.sh \
--val-folder recipes/papers/chief/validate \
--containers conda \
--rebuild
```