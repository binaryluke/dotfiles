#!/usr/bin/env node

import path from "path"
import fs from "fs"

const formatDate = (date) => {  
  if (!(date instanceof Date)) {
    throw new Error('Invalid "date" argument. You must pass a date instance')
  }

  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')

  return `${year}-${month}-${day}`
}

const titleCase = (str) => {
  str = str.toLowerCase().split(' ');
  for (var i = 0; i < str.length; i++) {
    str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1); 
  }
  return str.join(' ');
}

const createUpdateObject = (srcDir, srcFile, options) => {
	const srcPath = path.join(srcDir, srcFile + options.ext)
	const srcStat = fs.statSync(srcPath)
	const srcContents = fs.readFileSync(srcPath)

	const destFile = srcFile.replace(/ /g, "-").toLowerCase()
	const link = `[[${destFile}]]`
	const title = titleCase(srcFile.split(".")[0].replace(/-/g, " "))
	const destContents = `# ${title}\n\n${srcContents}\n\nCreated: ${formatDate(srcStat.birthtime)}`

	return {
		srcPath,
		srcFile,
		destFile,
		destContents,
		link,
		ext: options.ext,
	}
}

const createUpdateObjects = (srcDir) => {
	const files = fs.readdirSync(srcDir, {
		recursive: false,
		encoding: 'utf8',
	})

	return files
		.filter(file => file.length > 3 && file.slice(-3) === ".md")
		.map(file => file.slice(0, -3))
		.map(file => createUpdateObject(srcDir, file, { ext: ".md" }))
}

const processUpdateObject = (updateObject) => {
	const destPath = path.join(process.env.SECOND_BRAIN, '/archive', updateObject.destFile + updateObject.ext)

	if (fs.existsSync(destPath)) {
		console.error(`Skipping ${destPath}`)
		return null
	}

	fs.writeFileSync(destPath, updateObject.destContents, { encoding: 'utf8' })
	fs.rmSync(updateObject.srcPath)

	return updateObject.link
}

if (!process.env.SECOND_BRAIN) {
	console.error("Must set SECOND_BRAIN to your notes directory")
	process.exit(1)
}

console.log(`\n## ${process.argv[2]}`)
createUpdateObjects(path.join(process.env.SECOND_BRAIN, process.argv[2]))
	.map(processUpdateObject)
	.filter(link => link)
	.forEach(link => console.log(link))

