require recipes-core/images/core-image-minimal.bb

DESCRIPTION = "This is my own image for my Zybo."

inherit extrausers
EXTRA_USERS_PARAMS = "usermod -P root root;"
