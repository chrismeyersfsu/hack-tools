hack-tools
==========

An effort to save one-off hacking scripts that I end creating for hacking competitions or pen testing.

Recon
==

* dns brute-force that uses dictionary files https://github.com/chrismeyersfsu/subbrute
* find dns, email, and more via google crawl https://github.com/chrismeyersfsu/theHarvester

Scan
==

* Vulnerability scanner https://github.com/andresriancho/w3af

helpers.sh
==

`source helpers.sh`
Collection of shortcuts helpers

Forensics
==

* rekall:

```
docker run --rm -it -p 8000:8000 -v `pwd`:/home/nonroot/files remnux/rekall bash
mkdir my_worksheet
rekall webconsole --port 8004 --host 0.0.0.0 my_worksheet
```

* pngcheck: Find png inside a larger file `pngcheck -s <file>`
* exiftool: image metadata

Network
==

* wireshark:

RE
==

* ghidra: NSA tool like IDA Pro

Web
==

* graphql introspection:

```
{   __schema {     types {       name     }   } }
```

```
{
        "query": "query IntrospectionQuery {       __schema {         queryType { name }         mutationType { name }         subscriptionType { name }         types {           ...FullType         }         directives {           name           description           locations           args {             ...InputValue           }         }       }     }      fragment FullType on __Type {       kind       name       description       fields(includeDeprecated: true) {         name         description         args {           ...InputValue         }         type {           ...TypeRef         }         isDeprecated         deprecationReason       }       inputFields {         ...InputValue       }       interfaces {         ...TypeRef       }       enumValues(includeDeprecated: true) {         name         description         isDeprecated         deprecationReason       }       possibleTypes {         ...TypeRef       }     }      fragment InputValue on __InputValue {       name       description       type { ...TypeRef }       defaultValue     }      fragment TypeRef on __Type {       kind       name       ofType {         kind         name         ofType {           kind           name           ofType {             kind             name             ofType {               kind               name               ofType {                 kind                 name                 ofType {                   kind                   name                   ofType {                     kind                     name                   }                 }               }             }           }         }       }     }"
}```
