deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

module.exports =
	version: 1
	slug: 'raspberrypi4-64'
	aliases: [ 'seeed-reterminal' ]
	name: 'seeed reTerminal'
	arch: 'aarch64'
	state: 'new'

	instructions: commonImg.instructions
	gettingStartedLink:
		windows: 'https://www.balena.io/docs/learn/getting-started/raspberrypicm4-ioboard/nodejs/'
		osx: 'https://www.balena.io/docs/learn/getting-started/raspberrypicm4-ioboard/nodejs/'
		linux: 'https://www.balena.io/docs/learn/getting-started/raspberrypicm4-ioboard/nodejs/'

	options: [ networkOptions.group ]

	yocto:
		machine: 'seeed-reterminal'
		image: 'balena-image'
		fstype: 'balenaos-img'
		version: 'yocto-kirkstone'
		deployArtifact: 'balena-image-seeed-reterminal.balenaos-img'
		compressed: true

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	initialization: commonImg.initialization
