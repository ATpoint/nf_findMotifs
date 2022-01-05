#! /usr/bin/env nextflow

/* 
        SCHEMA DEFINITION FOR PARAMS VALIDATION
*/

def Map schema = [:] // don't change this line

// --------------------------------------------------------------------------------------------------------------

// generic options:
schema.min_nf_version = [value: '21.10.6', type: 'string', mandatory: true, allowed: '']

// workflow params
schema.target     = [value: '', type: 'string', mandatory: true]
schema.background = [value: '', type: 'string', mandatory: true]
schema.mode       = [value: 'single', type: 'string', mandatory: true, allowed: ['single', 'matched']]
schema.species    = [value: 'mouse', type: 'string', mandatory: true, allowed: ['human', 'mouse']]
schema.threads    = [value:1, type:'integer', mandatory:true]
schema.mem        = [value: '1.GB', type: 'string', mandatory: false, allowed: '', pattern: /^[0-9]+\.[0-9]*[K,M,G]B$/]
schema.outdir     = [value: './', type: 'string', mandatory: true]
schema.split_at   = [value: '_', type: 'string', mandatory: true]
schema.additional = [value: '', type: 'string', mandatory: false]

// env/docker params:
schema.container   = [value:'quay.io/biocontainers/homer:4.11--pl5262h7d875b9_5', type:'string', mandatory:true, allowed:'']
schema.environment = [value: "$baseDir/environment.yml", type:'string', mandatory:'true', allowed:'']

// --------------------------------------------------------------------------------------------------------------

return schema // don't change this line