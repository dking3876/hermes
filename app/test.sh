#!/usr/bin/env bash
MYVAR=something
cat <<EOL > create.json
{
    "name": "$MYVAR",
    "account": "dking3876",
    "repo": "onyx-framework",
    "scripts": [
        "grunt build",
        "npm publish"
    ],
    "deploy": [
        {
            "name": "Live",
            "branch": "stable",
            "beforeinstall": "scripts/before.sh",
            "afterinstall": "scripts/after.sh",
            "source": "",
            "target": ""
        },
        {
            "name": "Dev",
            "branch": "develop",
            "source": "",
            "target": "",
            "beforeinstall": "scripts/before.sh",
            "afterinstall": "scripts/after.sh"
        }
    ]
}
EOL