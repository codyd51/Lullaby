ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = Lullaby
Lullaby_FILES = Listener.xm
Lullaby_LIBRARIES = activator
Lullaby_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
