git clone --bare https://zaccam@bitbucket.dev.smbc.nasdaqomx.com/scm/~zaccam/dotfiles.git $HOME/.cfg
 function config {
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
 }
 mkdir -p .config-backup
 config checkout
 if [ $? = 0 ]; then
   echo "Checked out config.";
   else
     echo "Backing up pre-existing dot files.";
     config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
 fi;
 config checkout
 config config status.showUntrackedFiles no
 
# Ensure keys have correct perms
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
