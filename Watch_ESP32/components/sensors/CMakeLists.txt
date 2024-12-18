set(component_srcs "sensors.c")

set(idf_version "${IDF_VERSION_MAJOR}.${IDF_VERSION_MINOR}")

idf_component_register(SRCS "${component_srcs}" PRIV_REQUIRES driver INCLUDE_DIRS "include" ".")
