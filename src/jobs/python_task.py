import requests

from databricks.bundles.jobs import task


@task
def find_area_id(search_query: str) -> str:
    search_query = requests.utils.quote(search_query)

    overpass_url = "https://nominatim.openstreetmap.org/search"
    overpass_params = {"format": "json", "q": search_query}

    data = requests.get(overpass_url, params=overpass_params).json()

    # Extract the area ID from the response
    if len(data) > 0:
        area_id = data[0]["osm_id"]
        print("Area ID: ", area_id)

        return area_id
    else:
        raise Exception(f"'{search_query}' not found.")
