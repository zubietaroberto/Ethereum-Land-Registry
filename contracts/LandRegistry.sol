pragma solidity ^0.4.23;

contract LandRegistry {

    struct Point {
        uint id;
        address registrar;
        string latitude;
        string longitude;
    }

    struct Terrain {
        uint id;
        string owner;
        address registrar;
        mapping(uint => Point) polygon;
        uint polygonLength;
    }

    struct TerrainDatabase {
        mapping(uint => Terrain) list;
        uint size;
    }

    TerrainDatabase terrainDatabase;

    /* CONSTRUCTOR */
    constructor() public {
        terrainDatabase = TerrainDatabase({size: 0});
    }

    /* CREATION FUNCTIONS */
    function createTerrain(string newOwner) 
    public {
        terrainDatabase.size++;
        uint currentId = terrainDatabase.size;
        Terrain memory newTerrain = Terrain({
            id: currentId,
            registrar: msg.sender,
            owner: newOwner,
            polygonLength: 0
        });
        terrainDatabase.list[currentId] = newTerrain;
    }
    
    function addPointToTerrain(uint terrainId, string newLatitude, string newLongitude)
    terrainMustExist(terrainId)
    public {
        Terrain storage queriedTerrain = terrainDatabase.list[terrainId];
        queriedTerrain.polygonLength++;
        uint currentId = queriedTerrain.polygonLength;

        Point memory newPoint = Point({
            latitude: newLatitude,
            longitude: newLongitude,
            registrar: msg.sender,
            id: currentId
        });
        queriedTerrain.polygon[currentId] = newPoint;
    }

    /* VIEWS */
    function getTerrainCount()
    public view returns(uint terrainId) {
        return terrainDatabase.size;
    }

    function getTerrainData(uint terrainId) 
    public view returns(
        uint id,
        string owner,
        address registrar,
        uint polygonLength
    ){
        Terrain storage queriedTerrain = terrainDatabase.list[terrainId];
        return (
            queriedTerrain.id,
            queriedTerrain.owner,
            queriedTerrain.registrar,
            queriedTerrain.polygonLength
        );
    }

    function getPolygonItemCount(uint terrainId) 
    public view returns(uint polygonLength) {
        if (terrainId > terrainDatabase.size) return 0;
        return terrainDatabase.list[terrainId].polygonLength;
    }

    function getPolygonPoint(uint terrainId, uint polygonPointId)
    public view returns(
        string latitude,
        string longitude,
        address registrar
    ){
        Terrain storage queriedTerrain = terrainDatabase.list[terrainId];
        Point storage queriedPoint = queriedTerrain.polygon[polygonPointId];
        return (
            queriedPoint.latitude,
            queriedPoint.longitude,
            queriedPoint.registrar
        );
    }

    /* MODIFIERS */
    modifier terrainMustExist(uint terrainId){
        if (terrainId > terrainDatabase.size) revert();
        _;
    }

}