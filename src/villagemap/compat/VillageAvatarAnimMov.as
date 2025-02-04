package villagemap.compat
{
    import syscode.AvatarAnimMov;

    [Embed(source="/modules/villagemap_assets.swf", symbol="symbol121")]
    public class VillageAvatarAnimMov extends AvatarAnimMov
    {
        public function VillageAvatarAnimMov()
        {
            super(VillageAvatarMov);
        }
    }
}