# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export CLICOLOR=1
# Light background.
#export LSCOLORS=ExFxCxDxBxegedabagacad
# Dark background.
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

PATH=$PATH:~/'Android Studio.app'/sdk/platform-tools

case "$TERM" in
    screen*) PROMPT_COMMAND='echo -ne "\033k\033\0134"'
esac

alias logcat-color='adb logcat | grep -i `adb shell ps | grep -i 'com.homefinder' | cut -c10-15` | logcat-color'
alias setJdk6='export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)'
alias setJdk7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)'
alias setJdk8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'
alias simulators='xcrun simctl list'
