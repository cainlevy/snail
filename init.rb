require 'snail'

# Include hook code here
ActionView::Base.class_eval { include SnailHelpers }
