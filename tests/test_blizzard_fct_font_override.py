from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text()


def test_blizzard_fct_reapplies_selected_font():
    options = read("modules/options.lua")
    blizzard = read("modules/blizzard.lua")

    assert "x:UpdateBlizzardFCT()" in options, (
        "Changing Blizzard FCT font should immediately reapply the override."
    )
    assert "CombatTextFont:SetFont(" in blizzard, (
        "Blizzard FCT override should update the actual CombatTextFont object."
    )
    assert 'hooksecurefunc(elvui, "UpdateBlizzardFonts"' in blizzard, (
        "MuniganXCT should reapply its combat text font after ElvUI updates Blizzard fonts."
    )


if __name__ == "__main__":
    test_blizzard_fct_reapplies_selected_font()
    print("PASS")
