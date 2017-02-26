usage() { 
    echo "Usage: hermes [(command)] [options]";
};
executecmd(){
    cmd=$1
    eval $( echo mycmd=$cmd )
    eval $mycmd
}
runscript(){
   echo "scripts" 
}