# Hermes Continuous Integration
Hermes is a continuous integration and automated deployment tool for linux.  I build Hermes as most of the automation tools available were overly complicated for my simple purpose of getting my code to my servers.  Hermes accomplishes this in a simple and effective way.  
Currently Hermes is CLI only however I will be adding a GUI interface in the future as well as a user Portal to control your Hermes installation from a web browser.  

## Requirements: 
> * Linux   
> * jq  
> * git  

### Installation Debian/Ubuntu
```
	sudo apt-get install jq git
	wget https://github.com/hermes-ci/hermes/archive/v1.0.4-beta.tar.gz
	tar -xzvf v1.0.4-beta.tar.gz
    sudo chmod +x hermes-1.0.4-beta/hermes.sh
	sudo hermes-1.0.4-beta/hermes.sh install
```
### Installation RHEL/Fedora
```
	sudo yum install jq git
	wget https://github.com/hermes-ci/hermes/archive/v1.0.4-beta.tar.gz
	tar -xzvf v1.0.4-beta.tar.gz
    sudo chmod +x hermes-1.0.4-beta/hermes.sh
	sudo hermes-1.0.4-beta/hermes.sh install
```
### Hermes Configuration
Hermes  setup is fairly simple.  Heremes uses SSH to connect with your repos on Github and Bitbucket.  You do not need to directly integrate with your account, however for the "Pure Integrated Workflow" it will be required.

#### SSH Configration
Initialize the ssh-agent for use for automated deployment and add any stored ssh keys to the hermes keychain.
~~~
sudo hermes-ci sshconfig
~~~

Adding a new key to the keychain
Each deployment will require adding an ssh keypair. If you have not integratted your hermes installation with Git/Bitbucket and initialized your Oauth token you will be asked for your username and password when performing this cmd.  If you have integrated and initialized your token, you will not be prompted any further.
~~~
sudo hermes-ci keygen -a [account] -r [repo]
Enter Your github/bitbucket Username:
Enter your host password: 
~~~

#### Connect to Git/Bitbucket
> ## This feature is currently in development but will be available shortly.

Naviage to [Hermes-ci](https://hermes-ci.github.io) click on "Authorize Hermes".  Choose the service your want to connect with Hermes.  Follow the prompts to authorize Hermes for the Accounts you want to integrate with.  
After you will be redirected back to hermes-ci.github.io and will need to click "Get my Authorization Key".  Your key will than appear and you will need to save this key as you will not have access to it again.
> NOTE: You must be sure to save your key now as you will not have another oppertunity.

Once you have your OAuth key you can install the key by one of the following methods
1. Run the following cmd... For Git `sudo hermes-ci auth --token [Your Token] ` or for Bitbucket `sudo hermes-ci auth --token [Your Token] --bitbucket `
2. Save your token as plain txt file inside `var/opt/hermes-ci/keys` with the following filenames  
   * Github: GIT-token.txt  
   * Bitbucket: BIT-token.txt


## Operation

### Actions

#### update
To Update Hermes run `sudo hermes-ci update`

#### keygen  
Adds a public key to the repository for hermes to be able to clone and pull the repository.  If using an OAuth token you will not be prompted for your username and password.
 ~~~
sudo hermes-ci keygen -a [account] -r [repo]
Enter Your github/bitbucket Username:
Enter your host password: 
~~~


#### sshconfig  
 Initialize the ssh-agent for use for automated deployment and add any stored ssh keys to the hermes keychain.
~~~
sudo hermes-ci sshconfig
~~~
> Note: Hermes will initialize this command on each reboot of the server.  You may want to add a cronjob to check if the ssh-agent is still initialzed and run this command if it is not.

#### deploy  
  This command runs a deployment from a configuration file
  ```
  sudo hermes-ci deploy --config [account]-[repo] --tag [tag]
  ```

#### auth  
  This command will store your OAuth token for the appropriate service.  For bitbucket be sure to include the optional `--bitbucket` flag
  ```
  sudo hermes-ci auth --token [token] 
  ```

### Options
* -h | --help  
Shows the Hermes manual 
* -a | --account  
The Github/Bitbucket account for the repository you want to deploy
* -r | --repo `-r [reponame]`  
The Repository you want to deploy
* -b | --branch `-b [branch]`  
The Branch from the repo that you want to use for this deployment 
* -T | --tag `-T [tag for deployment]`  
Tags are required to match a deployment configuration to a specic deployment from a hermes.json file in a given repo.
* -S | --src `-S [folder in repo to deploy]`  
The source folder from the repo to deploy  
    * Note: If you have more than one source for deployment you should add your additional deployments to your afterinstalltion script
* -t | --target `-t [target folder on server]`  
The target folder for your deployment from your source.  
    * Note: If you have more than one target for source you should add your additional deployments to your afterinstalltion script
* --service `--service [service to pull files from]`  
Change the service your using for deployment.  
    * Note: Currently Hermes only supports Git and Bitbucket.
* --bitbucket  
Pass this flag to change to Bitbucket
* --auto  
Pass this flag to save the current configuration and run the deployment for each commit to the repository/branch
* --save  
Pass this flag to save the current configuration as a deployment file
* --report `--report [account name]-[repo name]`  
Display report for a given deployment `sudo hermes-ci --report [account]-[repo]`
* --afterinstall `--afterinstall [file in repo to run after deployment]`  
Script to run after the deployment runs.    
    * Note: The script must exist in the repository from your deployment
* --beforeinstall `--beforeinstall [file in repo to run before deployment]`  
Script to run before the deployment runs.  
    * Note: The script must exist in the repository from your deployment
* --config `--config [account name]-[repo name] --tag [tag for deployment]`  
The deployment configuration to use for a deployment `sudo hermes-ci deploy --config [account]-[repo]`
* --token  
Save an OAuth token for a given service `sudo hermes-ci auth --token [authtoken]`
    * Note: Pass the `--bitbucket` flag is saving for bitbucket

### Recommended Workflows
Below are some recommended Workflows and configuations for your deployments

#### Recommended file structure
```yml
	- build
	- dist  
	  - assets  
	  - app
	- scripts
	  - afterinstall.sh
	  - beforeinstall.sh
	- hermes.json
```
#### Add a configuration file to your repository
Adding a configuration file to your repository will tell hermes how to deploy your application.  Deployments are controlled by the "tag" for each deployement.  
When saving a deployment the `-t|--tag` is required.  Hermes will match the tag in the deployment file to the tag in your hermes.json file to determine how to deploy your application.
```json
{
    "name": "Hermes-ci",
    "account": "hermes-ci",
    "repo": "hermes",
    "scripts": [
        "npm -v",
        "grunt -v"
    ],
    "deploy": [
        {
            "tag": "live",
            "branch": "stable",
            "beforeinstall": "scripts/before-live.sh",
            "afterinstall": "scripts/after.sh",
            "source": "build",
            "target": "/var/www/html/hermes-live"
        },
        {
            "tag": "dev",
            "branch": "beta",
            "beforeinstall": "scripts/before.sh",
            "source": "build",
            "target": "/var/www/html/hermes-dev"
        }
    ]
}
```
Using the above configuration file in your repo and running `sudo hermes-ci deploy --config hremes-ci-hermes --tag dev` will run the "dev" deployment from the repo.  

The following workflows are using the account hermes-ci the repository demo-applicaiton the branch development

#### Manual Setup Workflow
Setup deployment via the command line by running the following commands
Add SSH keypair to your repository
```
sudo hermes-ci keygen -a hermes-ci -r demo-application
```
Run a deployment without a config file to deploy the demo-application from the build folder in the repo to the folder /var/www/demo on the server and run the script afterinstall.sh from the scripts folder in the repo after the deployment occurs
```
sudo hermes-ci -a hermes-ci -r demo-application -b development -S build -t /var/www/demo --afterinstall scripts/afterinstall.sh
```
#### Semi-Automated Workflow
1. Run multiple deployments by using a hermes.json file inside your repository.  
Setup a partially automated workflow by running the following commands and adding the following hermes.json file to your repository  

Add SSH keypair to your repository
```
sudo hermes-ci keygen -a hermes-ci -r demo-application
```
Add the following hermes.json file to the root of your repository
```json
{
    "name": "My demo",
    "account": "hermes-ci",
    "repo": "demo-application",
    "deploy": [
        {
            "tag": "live",
            "branch": "stable",
            "beforeinstall": "scripts/before-live.sh",
            "afterinstall": "scripts/after.sh",
            "source": "build",
            "target": "/var/www/html/hermes-live"
        },
        {
            "tag": "dev",
            "branch": "development",
            "afterinstall": "scripts/afterinstall.sh",
            "source": "build",
            "target": "/var/www/demo"
        }
    ]
}

```
Run deployment from the command line.
```
sudo hermes-ci -a hermes-ci -r demo-application -b development -t dev
```
Optionally you can can add the above command to a cronjob.  
> Note: recommended cronjob time is */2 * * * *
2. Run the deployment automatically by saving a deployment file and combining with a hermes.json file.  
Use the above workflow with also running the following command.
```
sudo hermes-ci -a hermes-ci -r demo-application -b development --save
```
run the following command and/or add the following to a cronjob
```
sudo hermes-ci deploy --config hermes-ci-demo-application --tag dev
```

#### Pure Automated Workflow
Setup a completely automated workflow following the below steps. The following sets up deployments for the account bobsmith

1. Create a repository using the following folder structure  
```yml
	- deploy
	- scripts
	  - after.sh
	- hermes.json
```
2. Create the hermes.json file in the repository
```json
{
    "name": "My deployments",
    "account": "bobsmith",
    "repo": "deployment",
    "deploy": [
        {
            "tag": "live",
            "branch": "master",
            "afterinstall": "scripts/after.sh",
            "source": "deploy",
            "target": "/var/www/deployment"
        }
    ]
}
```
3. Create a deployment for your application and set to auto deploy
```
sudo hermes-ci keygen -a bobsmith -r deployments
sudo hermes-ci -a bobsmith -r deployments -b master -T live --save --auto
```

### Hermes GUI interface
> This is currently a work in progress and not yet fully tested feature

localhost/hermes-ci