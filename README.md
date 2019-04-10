# swarm-home

`bzz:/theswarm.eth`

or web gateway: http://swarm-gateways.net/bzz:/theswarm.eth/

## Warning

Don't make changes on the `gh-pages` branch. Commit changes to the `master` branch and Travis will take care of the rest.

## Deployment

To automatically deploy the website you just need to create a git tag with the following format: `v.X.Y.Z` . Make sure to check the most [recent releases](https://github.com/ethersphere/swarm-home/releases) and bump the version up.



For example:

 ```sh
# Create a v1.0.0 git tag that will trigger
# an automated deployment of the website
git tag v1.0.0
git push origin v1.0.0
 ```
