Steps to run this repo:
1. Clone this repo: git clone https://github.com/just-vile/NT548-Lab2-Cloudformation.git
2. Create a CodeCommit repo in AWS console (before create the CodeCommit repo, you must delete the folder '.git' in current directory) named 'Group21-Lab2'.
3. In AWS console, click IAM, then create a Git credentials to access to CodeCommit.
4. Clone the CodeCommit repo to your computer, and type the Git credentials that already created.
5. Push this repo to CodeCommit
   ```sh
   git add .
   git commit -m 'first commit'
   git push
   ```
6. Create a CodeBuild project:
```sh
   - Name: Cloudformation-validation
   - Source: AWS CodeCommit
   - Repository: Group21-Lab2. Branch: Master
   - Click 'Use buildspec file
```
7. Create a CodePipeline:
```sh
  - Name: Group21-Pipeline
  - All other options set as Default
  - Source stage: AWS CodeCommit you just created
  - Build stage: AWS CodeBuild you just created
  - Deploy stage:
      + Deploy provider: AWS Cloudformation
      + Input artifact: BuildArtifact
      + Action mode: Create or update stack
      + Stack name: Group21-Stack
      + Template: Artifact name: BuildArtifact; Filename: template.yaml
```
Then, you should have your own AWS Infrastructure with this pipeline.
