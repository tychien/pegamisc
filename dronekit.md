# Dronekit Error Code


 Start simulator (SITL)
Starting copter simulator (SITL)
SITL already Downloaded and Extracted.
Ready to boot.
Traceback (most recent call last):
  File "/home/tychien/my_drone_project/helloDrone.py", line 7, in <module>
    from dronekit import connect, VehicleMode
  File "/home/tychien/my_drone_project/venv_dronekit/lib/python3.12/site-packages/dronekit/__init__.py", line 2689, in <module>
    class Parameters(collections.MutableMapping, HasObservers):
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: module 'collections' has no attribute 'MutableMapping'

