@echo off
FOR /d %%f IN (*.*) do call copy-resource.cmd %%f
rem pause