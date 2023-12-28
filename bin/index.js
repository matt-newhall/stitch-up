#! /usr/bin/env node

import { exec } from 'child_process';
import inquirer from 'inquirer';

const repoName = process.argv[2]
if (repoName === undefined) {
  throw new Error("Unspecified repository name.")
}

inquirer
  .prompt([
    {
      type: 'list',
      name: 'repoSetting',
      message: 'How would you like to configure repo?',
      choices: ["Frontend Only", "Fullstack"],
    },
  ])
  .then(answer => {
    const isFullstack = answer.repoSetting === 'Fullstack'
    const command = `bin/run-create.sh ${repoName} ${isFullstack}`

    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error(`Error: ${error.message}`);
        return;
      }
      if (stderr) {
        console.error(`Error: ${stderr}`);
        return;
      }
      console.log(`Success: ${stdout}`);
    });
  });
