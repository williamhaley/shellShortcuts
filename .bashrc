# .bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

PATH=$PATH:$HOME/bin:~/.rvm/bin:~/'Android Studio.app'/sdk/platform-tools

alias stack='currentDir=$(pwd) && cd /apps/chef/scripts && vagrant ssh -c "sudo sh /apps/chef/scripts/restart.sh" && cd "$currentDir"'
alias logcat-color='adb logcat | grep -i `adb shell ps | grep -i 'com.homefinder' | cut -c10-15` | logcat-color'
alias clj='java -cp ~/.m2/repository/org/clojure/clojure/1.5.1/clojure-1.5.1.jar clojure.main'
alias jenkins="nohup java -jar ~/Downloads/jenkins.war --httpPort=8081 --ajp13Port=8010 > /tmp/jenkins.log 2>&1 &"
alias clean-eclipse="sudo rm -r ~/Workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi && sudo rm -rf ~/Workspace/.metadata"
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias wsgrep='grep --color --exclude-dir=".git" --exclude-dir="templates_c" "$@"'

alias sublime='"/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"'

alias simulators='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/simctl list'

clearcache       () { (cd /apps/chef/scripts/ && vagrant ssh -c "sudo rm -rf /export/cache/nginx/* && sudo rm /apps/*/_smarty/templates_c" ) }
git-pull-for-sha () { git log --merges --ancestry-path --oneline $1..master | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2-; } # http://joey.aghion.com/find-the-github-pull-request-for-a-commit/
git-restore-file () { git checkout $(git rev-list -n 1 HEAD -- "$@")^ -- "$@"; }

# Quickly set the sdk in use (setjdk 1.7.0_51)
# http://www.jayway.com/2014/01/15/how-to-switch-jdk-version-on-mac-os-x-maverick/
function setjdk() {
	if [ $# -ne 0 ]; then
		removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
   		if [ -n "${JAVA_HOME+x}" ]; then
    		removeFromPath $JAVA_HOME
   		fi
   		export JAVA_HOME=`/usr/libexec/java_home -v $@`
   		export PATH=$JAVA_HOME/bin:$PATH
  	fi
}
 
function removeFromPath() {
	export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}
