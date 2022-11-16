import multiprocessing

workers = multiprocessing.cpu_count() * 2 + 1
bind = "unix:material_manager.sock"
umask = 0o007
reload = True

# Log to the stdout and stderr
accesslog = "-"
errorlog = "-"
