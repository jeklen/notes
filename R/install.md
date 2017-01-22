## install R
first I checked this website
https://cran.r-project.org/bin/linux/debian/
https://mirrors.tuna.tsinghua.edu.cn/CRAN/

```
apt-cache search "^r-.*" | sort

apt-get update
apt-get install r-base r-base-dev

# to get better performance for linear algebra operations
apt-get install libatlas3-base

## problems installing R packags
I cant't install R packages and always get the error: 
*installing of package 'XXX' had non-zero exit status*

then I find the answer in this website:
https://github.com/rocker-org/rocker/issues/124

and i fixed it after the package
```apt-get install libgdal-dev```
