# General Snakemake top-matter

# Snakemake can run a rule multiple times in order to collect benchmark information.
#  Set number of benchmarks to run to 1 - we can now use this variable in our rules.
N_BENCHMARKS = 1

# Jobs can be run inside a singularity container when using --use-singularity.
#  Specifying a container at the top-level provides the same image to all jobs.
singularity:
	"docker://continuumio/miniconda3:4.10.3p0"

# Include other rules from other Snakefiles.
include:
	"rules/misc.smk",

# While rules should be run locally (e.g. head node) rather than being submitted as jobs.
localrules:
	all,

# Pseudorules to define convienient groups of target files.
#  By convention, the first should be called "all" as it will gets this alias anyway.
#  Simply specify all the required target files as the input to the pseudorule.
#  Use expand() as a convienient way to create all combinations of filenames.
rule all:
	input:
		# Explicitly defining EVERY target file quickly becomes a pain!
		'test/output/demo_minimal',
		# Use expand() as a convienient way to define many files with less reduncancy.
		# By default, expand() generates all combinations (products) of filenames if there is more than 1 replacement variable
		expand(
			'test/output/demo_{suffix}',
			suffix = [
				'realistic',
				'wildcards',
			],
		),

# Rules define, at a minimum, both input and output files and a way to make the output from the input.
#  Here we use the "shell" directive, but you could use "run" (Python code), "script" (external Python, R, Rmd, Julia and Rust), "notebook" for Jupyter notebook.
rule demo_minimal:
	input:
		'test/input/demo.in',
	output:
		'test/output/demo_minimal',
	shell:
		"""
		sed -e '1~2d' < {input} > {output}
		"""

# A more realistic example will specify a few more directives:
#  conda     - A conda environment file detailing the tools required for this rule to run
#  resources - The job resources to request from Slurm. Supports "mem_gb", "time_hr" and "threads". They must be integer values.
#  threads   - Number of threads available to the rule. This should match what is specified in the resources directive.
#  benchmark - Where to save benchmark stats and how many benchmarks to run
rule demo_realistic:
	input:
		'test/input/demo.in',
	output:
		'test/output/demo_realistic',
	conda:
		'envs/demo.yaml',
	resources:
		mem_gb  = 4,
		time_hr = 8,
		threads = 2,
	threads:
		2,
	benchmark:
		repeat("test/benchmarks/demo_realistic.txt", N_BENCHMARKS),
	shell:
		"""
		sed -e '1~3d' < {input} > {output}
		"""
# Rather than having a rule defined for EVERY possible output file, generalise the rules using wildcards.
# Snakemake identifies the rule (or chain of rules) capable of making the requested file(s) by matching the filepath to the output directives of rules.
# Exact matches take precedence and then wildcard (think regular expression) matches.
# Wildcard values are defined via matching the output file(s) and "reused" in constructing identifying the input file(s).
# All outout directives (output, log and benchmark) must specify ALL the same wildcards.
rule demo_wildcards:
	input:
		'test/input/{a_wildcard}.in',
	output:
		'test/output/{a_wildcard}_wildcards',
	conda:
		'envs/demo.yaml',
	resources:
		mem_gb  = 1,
		time_hr = 1,
		threads = 1,
	threads:
		1,
	benchmark:
		repeat("test/benchmarks/{a_wildcard}_wildcards.txt", N_BENCHMARKS),
	shell:
		"""
		sed -e '1~4d' < {input} > {output}
		"""
