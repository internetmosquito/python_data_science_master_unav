FROM continuumio/miniconda3:latest
RUN mkdir /opt/notebooks
RUN /opt/conda/bin/conda install numpy
RUN /opt/conda/bin/conda install pandas
RUN /opt/conda/bin/conda install scipy
RUN /opt/conda/bin/conda install matplotlib
RUN /opt/conda/bin/conda install seaborn
RUN /opt/conda/bin/conda install scikit-learn
RUN /opt/conda/bin/conda install jupyter -y
RUN /opt/conda/bin/pip install hide_code
RUN /opt/conda/bin/jupyter nbextension install --py hide_code
RUN /opt/conda/bin/jupyter nbextension enable --py hide_code
RUN /opt/conda/bin/jupyter serverextension enable --py hide_code
# COPY in your custom config 
# COPY jupyter_notebook_config.py /.jupyter/jupyter_notebook_config.py
EXPOSE 8888
# RUN the notebook
CMD ["/opt/conda/bin/jupyter", "notebook", "--notebook-dir=/opt/notebooks", "--ip='*'", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
